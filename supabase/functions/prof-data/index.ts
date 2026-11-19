// Edge function « prof-data » — sert l'Espace Prof de l'app Annuaire CMM.
// Le code enseignant n'est PLUS dans le code client : il est vérifié ici,
// côté serveur, contre le secret PROF_CODE (supabase secrets set PROF_CODE=...).
//
// Actions (POST JSON {code, action?, detail?}) :
//  - (défaut)        -> {saisies, evenements}      : données de l'Espace Prof
//  - action="export" -> journalise l'export dans exports_log, renvoie {ok, totalExports}
//  - action="log"    -> {log:[...]}                 : historique des exports (pour le prof)
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const PROF_CODE = Deno.env.get("PROF_CODE") ?? "";

function reponse(statut: number, corps: unknown): Response {
  return new Response(JSON.stringify(corps), {
    status: statut,
    headers: { "Content-Type": "application/json", "Cache-Control": "no-store" },
  });
}

function codeValide(code: string): boolean {
  const a = new TextEncoder().encode(code);
  const b = new TextEncoder().encode(PROF_CODE);
  let diff = a.length === b.length ? 0 : 1;
  const n = Math.max(a.length, b.length);
  for (let i = 0; i < n; i++) diff |= (a[i % a.length] ?? 0) ^ (b[i % b.length] ?? 0);
  return !!PROF_CODE && diff === 0;
}

serve(async (req: Request) => {
  if (req.method !== "POST") return reponse(405, { error: "method_not_allowed" });
  let code = "", action = "", detail = "";
  try {
    const body = await req.json();
    code = String(body?.code ?? "").trim();
    action = String(body?.action ?? "").trim();
    detail = String(body?.detail ?? "").slice(0, 200);
  } catch {
    return reponse(400, { error: "bad_request" });
  }
  if (!codeValide(code)) return reponse(401, { error: "unauthorized" });

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
  );

  if (action === "export") {
    // Journalise chaque export côté serveur (aucun export n'est possible sans
    // ce passage obligé : le bouton n'existe que dans l'Espace Prof).
    const ins = await supabase.from("exports_log").insert({ action: "export", detail });
    if (ins.error) return reponse(500, { error: "db_error" });
    const c = await supabase.from("exports_log").select("id", { count: "exact", head: true });
    return reponse(200, { ok: true, totalExports: c.count ?? null });
  }

  if (action === "log") {
    const log = await supabase
      .from("exports_log")
      .select("*")
      .order("horodatage", { ascending: false })
      .limit(100);
    if (log.error) return reponse(500, { error: "db_error" });
    return reponse(200, { log: log.data ?? [] });
  }

  const [saisies, evenements] = await Promise.all([
    supabase.from("saisies").select("*"),
    supabase.from("evenements").select("*").order("horodatage", { ascending: true }),
  ]);
  if (saisies.error || evenements.error) return reponse(500, { error: "db_error" });
  return reponse(200, { saisies: saisies.data ?? [], evenements: evenements.data ?? [] });
});

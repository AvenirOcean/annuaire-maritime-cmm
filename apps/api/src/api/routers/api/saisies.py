"""Saisies endpoints: the shared, instantly-collected student work.

Both endpoints require the mission access code in the ``X-Mission-Code`` header, so the base is
not readable or writable by anyone without the code handed out in class. Upserts are keyed by
``N° fiche``: the server is the source of truth, last write wins.
"""

from datetime import UTC, datetime

from db.engine import get_session_maker
from db.models.saisie import Saisie
from env.mission import env as mission_env
from fastapi import APIRouter, Header, HTTPException, status
from pydantic import BaseModel, Field
from sqlmodel import select

router = APIRouter()


def _verifier_code(x_mission_code: str | None) -> None:
    if not x_mission_code or x_mission_code.strip() != mission_env.mission_code.strip():
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Code mission invalide. Demandez le code à votre enseignant.",
        )


class SaisiePayload(BaseModel):
    statut: str = Field(default="", max_length=64)
    tel: str = Field(default="", max_length=64)
    eml: str = Field(default="", max_length=254)
    web: str = Field(default="", max_length=512)
    dte: str = Field(default="", max_length=32)
    src: str = Field(default="", max_length=64)
    obs: str = Field(default="", max_length=2000)
    auteur: str = Field(default="", max_length=64)
    emoji: str = Field(default="", max_length=16)


class SaisieOut(SaisiePayload):
    no_fiche: str
    maj: str


async def _session():
    return get_session_maker()()


@router.get(
    "",
    operation_id="lister_saisies",
    summary="Toutes les saisies synchronisées (code mission requis)",
)
async def lister_saisies(x_mission_code: str | None = Header(default=None)) -> list[SaisieOut]:
    _verifier_code(x_mission_code)
    async with await _session() as session:
        saisies = (await session.execute(select(Saisie).order_by(Saisie.no_fiche))).scalars().all()
        return [
            SaisieOut(
                no_fiche=s.no_fiche,
                statut=s.statut,
                tel=s.tel,
                eml=s.eml,
                web=s.web,
                dte=s.dte,
                src=s.src,
                obs=s.obs,
                auteur=s.auteur,
                emoji=s.emoji,
                maj=s.maj.isoformat(),
            )
            for s in saisies
        ]


@router.put(
    "/{no_fiche}",
    operation_id="enregistrer_saisie",
    summary="Crée ou met à jour la saisie d'une fiche (code mission requis)",
)
async def enregistrer_saisie(
    no_fiche: str,
    payload: SaisiePayload,
    x_mission_code: str | None = Header(default=None),
) -> SaisieOut:
    _verifier_code(x_mission_code)
    no = no_fiche.strip()
    if not no:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="N° de fiche manquant.")
    async with await _session() as session:
        saisie = await session.get(Saisie, no)
        if saisie is None:
            saisie = Saisie(no_fiche=no)
            session.add(saisie)
        for champ in ("statut", "tel", "eml", "web", "dte", "src", "obs", "auteur", "emoji"):
            setattr(saisie, champ, getattr(payload, champ))
        saisie.maj = datetime.now(UTC)
        await session.commit()
        await session.refresh(saisie)
        return SaisieOut(
            no_fiche=saisie.no_fiche,
            statut=saisie.statut,
            tel=saisie.tel,
            eml=saisie.eml,
            web=saisie.web,
            dte=saisie.dte,
            src=saisie.src,
            obs=saisie.obs,
            auteur=saisie.auteur,
            emoji=saisie.emoji,
            maj=saisie.maj.isoformat(),
        )

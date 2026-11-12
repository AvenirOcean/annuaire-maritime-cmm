"""One row per fiche the students have filled in: the server-side source of truth for saisies.

Keyed by ``N° fiche`` so every student's edit of the same fiche converges on one row (last write
wins), and the full table is a small join target for the CMM's export.
"""

from datetime import UTC, datetime

from sqlmodel import Field, SQLModel


def _utcnow() -> datetime:
    return datetime.now(UTC)


class Saisie(SQLModel, table=True):
    __tablename__ = "saisies"

    no_fiche: str = Field(default="", primary_key=True)
    statut: str = Field(default="", index=True)
    tel: str = Field(default="")
    eml: str = Field(default="")
    web: str = Field(default="")
    dte: str = Field(default="")
    src: str = Field(default="")
    obs: str = Field(default="")
    auteur: str = Field(default="", index=True)
    emoji: str = Field(default="")
    maj: datetime = Field(default_factory=_utcnow)

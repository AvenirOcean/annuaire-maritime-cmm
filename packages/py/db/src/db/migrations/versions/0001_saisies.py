"""Baseline: saisies table for the annuaire qualification mission.

Revision ID: 0001_saisies
Revises:
Create Date: 2026-11-12

"""

from collections.abc import Sequence

import sqlalchemy as sa
import sqlmodel.sql.sqltypes
from alembic import op

revision: str = "0001_saisies"
down_revision: str | Sequence[str] | None = None
branch_labels: str | Sequence[str] | None = ("annuaire_saisies",)
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "saisies",
        sa.Column("no_fiche", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("statut", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("tel", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("eml", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("web", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("dte", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("src", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("obs", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("auteur", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("emoji", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column(
            "maj",
            sa.DateTime(),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.PrimaryKeyConstraint("no_fiche"),
    )
    op.create_index("ix_saisies_statut", "saisies", ["statut"])
    op.create_index("ix_saisies_auteur", "saisies", ["auteur"])


def downgrade() -> None:
    op.drop_index("ix_saisies_auteur", table_name="saisies")
    op.drop_index("ix_saisies_statut", table_name="saisies")
    op.drop_table("saisies")

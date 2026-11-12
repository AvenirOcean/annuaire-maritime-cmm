"""Mission access settings: the shared code the students type once to unlock synchronisation."""

from env._base import BaseEnv


class Env(BaseEnv):
    mission_code: str = "CMM-MARIN-2026"


env = Env()

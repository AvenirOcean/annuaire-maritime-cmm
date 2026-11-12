"""The HTTP API mounted at ``/api``; child packages declare access rules.

The subtree is declared anonymous at the router level: the saisies routes enforce their own
mission access code (``X-Mission-Code``), and the health routes are probe infrastructure.
"""

from fastapi import params

dependencies: tuple[params.Depends, ...] = ()

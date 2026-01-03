#!/bin/bash

# Default to Beijing if no location is provided
LOCATION="${1:-Beijing}"

# Use curl to fetch weather from wttr.in
# -s: Silent mode (don't show progress meter)
# ?0: Only show current weather and today's forecast (reduces verbosity)
# We can adjust flags as needed.
curl -s "wttr.in/$LOCATION?0"

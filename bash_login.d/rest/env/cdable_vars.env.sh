# Add cdable_vars here iff cdable_vars bash option is set
[[ -o cdable_vars ]] || return 0

# where reading material is kept.
u.env.export -z media -d ~/pools/tank/media
u.env.export -z edoc -d ${media}/Documents/edoc

# use a consistent naming convention for cdable vars
u.env.export -z bashenv -d "${BASHENV}"

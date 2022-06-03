#find -name *.tex!/usr/bin/env bash
# -----------------------------------
#| bgll.fullstackfullstock.com       |
#| github.com/babidiii               |
# -----------------------------------

RESET=$(tput sgr0)
BOLD=$(tput bold)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)

log(){
  level="${1}"
  msg=${2}

  case "${level}" in
      "error")
	  color=${RED}
	  ;;
      "info")
	  color="${BLUE}"
	  ;;
      "warn")
	  color="${YEL}"
	  ;;
      "success")
	  color="${GREEN}"
	  ;;
  esac
  printf "* %s\n" "${BOLD}${color}${msg}${RESET}"
}

is_command_installed(){
  local command_name=${1}
  if [ ! -n "$(command -v ${command_name})" ]; then
    log "error" "${command_name} command not installed"
    return 1
  else
    log "success" "${command_name} command installed"
    return 0
  fi
}

main(){
  image_name="pandex"
  dockerfile_path="./Dockerfile"
  context_path="$(dirname ${dockerfile_path})"
  build_dir="./build"

  if is_command_installed "podman" ; then 
    cmd=(podman)
    build_cmd=(podman)
    run_cmd=(podman)
  elif is_command_installed "docker"; then
    cmd=(docker)
    build_cmd=(docker)
    run_cmd=(docker)
  else 
    log "error" "You need to install either docker or podman"
    exit 1
  fi

  build_cmd+=(build -t "${image_name}" -f "${dockerfile_path}" "${context_path}")
  run_cmd+=(run --rm -ti --volume "`pwd`:/data" --entrypoint "/data/pandex_compile.sh" "${image_name}")

  [ -d "${build_dir}" ] || mkdir "${build_dir}" 

  log "info" "Checking if ${image_name} image exists"
  res=$($cmd images -q ${image_name} )
  if [[ -z "${res}" ]]; then
    log "error" "Image doesn't exist"
    log "info" "Building the ${image_name} image"

    ${build_cmd[@]}
    [[ $? -ne 0 ]] && log "error" "Error building the image" && exit 1
  else
    log "info" "Image ${image_name} exist"
  fi

  log "info" "Running the container"
  ${run_cmd[@]}
}

main "${@}"


function program_is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0; }
  # return value
  echo "$return_"
}

function echo_red {
  red='\033[0;31m'
  colorless='\033[0m'
  printf "${red}✘ ${1}${colorless}\n"
}

function thought_provoking_cowsay {
  cowsay $(node $ZSH_CUSTOM/plugins/thought-provoking-cowsay/cowsay.js)
}

# if user has already installed the "cowsay" npm package:
  # print a thought-provoking message using cowsa
# else:
  # print message instructing them to install the "cowsay" npm package
function main {
  if [ -n $(program_is_installed cowsay) ]; then
    thought_provoking_cowsay
  else
    echo_red '\nIn order to use "Thought-Provoking Cowsay" plugin, you must first install the "cowsay" npm plugin:\n'
    echo '$ npm install cowsay'
  fi
}

main

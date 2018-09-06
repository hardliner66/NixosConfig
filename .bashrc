m -r ~/.nix-defexpr > /dev/null
ln -s ~/Code/nixpkgs ~/.nix-defexpr

# Then export the right env variables:
export NIX_PATH=~/Code:nixos-config=/etc/nixos/configuration.nix;

# Then export the right env variables:
nix-search(){ echo "Searching..."; nix-env -qaP --description * | grep -i "$1"; }

nix-install(){ nix-env -iA $1; }

function gitbranchname {
  git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3
}
function gitbranchprompt {
  local branch=`gitbranchname`
  if [ $branch ]; then printf " [%s]" $branch; fi
}
PS1="\u@\h \[\033[1;36m\]\W\[\033[0;32m\]\$(gitbranchprompt)\[\033[0m\] \$ "

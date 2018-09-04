DO_REBOOT=1
for i in "$@"
do
case $i in
    -n|--no-reboot)
    DO_REBOOT=0
    ;;
    *)
    ;;
esac
done

if [ "$DO_REBOOT" -eq "1" ]; then
    sudo -- sh -c 'cp configuration.nix /etc/nixos/configuration.nix && nixos-rebuild switch && reboot';
else
    sudo -- sh -c 'cp configuration.nix /etc/nixos/configuration.nix && nixos-rebuild switch';
fi

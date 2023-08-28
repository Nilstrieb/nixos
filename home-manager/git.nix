{ pkgs }: {
  enable = true;

  userEmail = "48135649+Nilstrieb@users.noreply.github.com";
  userName = "Nilstrieb";

  aliases = {
    hardupdate = "!git fetch && git reset --hard \"origin/$(git rev-parse --abbrev-ref HEAD)\"";
    fpush = "push --force-with-lease";
    resq = "rebase --autosquash -i";
    pfush = "!echo \"hör uf ume z'pfusche und machs richtig\"";
  };
  difftastic = {
    enable = true;
  };
  extraConfig = {
    core.autocrlf = false;
    core.editor = "nvim";
    pull.ff = "only";
    init.defaultBranch = "main";
  };
}

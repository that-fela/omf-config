# Based on Bira theme from oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/bira.zsh-theme
# and
# Based on clearance theme: https://github.com/oh-my-fish/theme-clearance/blob/master/functions/fish_prompt.fish

function __user_host
  set -l content 
  if [ (id -u) = "0" ];
    echo -n (set_color red)
  else
    echo -n (set_color green)
  end
  echo -n $USER@(hostname|cut -d . -f 1) (set color normal)
end

function __current_path
  echo -n (set_color --bold blue) (pwd | sed "s:^$HOME:~:") (set_color normal) 
end

function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function fish_prompt
  set -l last_status $status

  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)

  echo -e ''

  if set -q VIRTUAL_ENV
      echo -n -s (set_color -b cyan black) '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  end

  __user_host
  __current_path

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info '(' $yellow $git_branch "*" $normal ')'
    else
      set git_info '(' $green $git_branch $normal ')'
    end
    echo -n -s ' · ' $git_info $normal
  end

  set -l prompt_color $red
  if test $last_status = 0
    set prompt_color $normal
  end

  # Terminate with a nice prompt char
  echo -e ''
  echo -e -n -s $prompt_color '> ' $normal
end

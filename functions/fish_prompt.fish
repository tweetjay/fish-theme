set fish_color_search_match --background=magenta

function fish_prompt --description 'Write out the prompt'
  set __fish_prompt_char_final '→'

  set -l last_status $status

  # Just calculate this once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  # Hack; fish_config only copies the fish_prompt function (see #736)
  if not set -q -g __fish_classic_git_functions_defined
    set -g __fish_classic_git_functions_defined

    function __fish_repaint_user --on-variable fish_color_user --description "Event handler, repaint when fish_color_user changes"
      if status --is-interactive
        commandline -f repaint ^/dev/null
      end
    end

    function __fish_repaint_host --on-variable fish_color_host --description "Event handler, repaint when fish_color_host changes"
      if status --is-interactive
        commandline -f repaint ^/dev/null
      end
    end

    function __fish_repaint_status --on-variable fish_color_status --description "Event handler; repaint when fish_color_status changes"
      if status --is-interactive
        commandline -f repaint ^/dev/null
      end
    end

    function __fish_repaint_bind_mode --on-variable fish_key_bindings --description "Event handler; repaint when fish_key_bindings changes"
      if status --is-interactive
        commandline -f repaint ^/dev/null
      end
    end

    # initialize our new variables
    if not set -q __fish_classic_git_prompt_initialized
      set -qU fish_color_user; or set -U fish_color_user -o green
      set -qU fish_color_host; or set -U fish_color_host -o cyan
      set -qU fish_color_status; or set -U fish_color_status red
      set -U __fish_classic_git_prompt_initialized
    end
  end

  set -l color_cwd
  set -l prefix
  set -l current_user

  switch $USER
  case root toor
    if set -q fish_color_cwd_root
      set color_cwd $fish_color_cwd_root
    else
      set color_cwd $fish_color_cwd
    end
    set suffix '#'
  case (whoami)
    set current_user ''
    set color_cwd $fish_color_cwd
    set suffix $__fish_prompt_char_final
  case '*'
    set current_user $USER
    set color_cwd $fish_color_cwd
    set suffix $__fish_prompt_char_final
  end

  if test -z $current_user
    set prompt_user_host (set_color $fish_color_user) $current_user $normal @ (set_color $fish_color_host) $__fish_prompt_hostname $normal
  end

  set -l prompt_status
  if test $last_status -ne 0
    set prompt_status ' ' (set_color $fish_color_status) "[$last_status]" "$normal"
  end

  echo -n -s $prompt_user_host ' '
  echo -n -s (set_color $color_cwd) (prompt_pwd) $normal
  echo -n -s $c1 (__tweetjay_git_prompt) $normal
  echo -n -s $prompt_status
  printf "\n $suffix "
end

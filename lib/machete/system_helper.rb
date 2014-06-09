module Machete
  module SystemHelper

    def run_cmd(cmd)
      Machete.logger.info "$ #{cmd}"
      result = `#{cmd}`
      Machete.logger.info result
      result
    end

    def vagrant_cwd
      return @vagrant_cwd if @vagrant_cwd

      if ENV['VAGRANT_CWD']
        @vagrant_cwd = ENV['VAGRANT_CWD']
      else
        Machete.logger.error "No VAGRANT_CWD. You probably want:\nVAGRANT_CWD=$HOME/workspace/bosh-lite\nor\nVAGRANT_CWD=$HOME/workspace/bosh-lite-2nd-instance"
      end
    end

    def set_vagrant_working_directory
      # this is local to the clean env - thats why it seems strange that we set it often.
      ENV['VAGRANT_CWD'] = vagrant_cwd
    end

    def run_on_host(command)
      with_vagrant_env { `vagrant ssh -c "#{command}" 2>&1` }
    end

    def with_vagrant_env
      Bundler.with_clean_env do
        set_vagrant_working_directory
        yield
      end
    end

  end
end

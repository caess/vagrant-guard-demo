module VagrantHelpers
  def vagrant_execute_command(vm = nil)
    "vagrant ssh-config %s | ssh -q -F /dev/stdin %s" %
      [vm || "", vm || "default"]
  end
  
  def vagrant_interactive_command(vm = nil)
    "vagrant ssh" + (vm ? " #{vm}" : "")
  end
end

World(VagrantHelpers)
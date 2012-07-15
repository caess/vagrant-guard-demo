require 'guard/cucumber'

# This block simply calls vagrant provision via a shell
# And shows the output
def vagrant_provision
  IO.popen("vagrant provision && touch .vagrant_last_provisioned") do |output|
    while line = output.gets do
      puts line
    end
  end
end

# So determine if all tests (both rspec and cucumber have been passed)
# This is used to only invoke the vagrant_provision if all test show green
def all_tests_pass
  cucumber_guard = ::Guard.guards({ :name => 'cucumber', :group => 'puppet_tests'}).first
  cucumber_passed = cucumber_guard.instance_variable_get("@failed_paths").empty?
  rspec_guard = ::Guard.guards({ :name => 'rspec', :group => 'puppet_tests'}).first
  rspec_passed = rspec_guard.instance_variable_get("@failed_paths").empty?
  return rspec_passed && cucumber_passed
end


# Actual guard section
group :puppet_tests do

  # Run rspec-puppet tests
  # --format documentation : for better output
  # :spec_paths to pass the correct path to look for features
  guard :rspec, :version => 2, :cli => "--color --format documentation", :spec_paths => ["puppet-repo"]  do
    # Match any .pp file (but be carefull not include and dot-temporary files)
    watch(%r{^puppet-repo/.*/[^.]*\.pp$}) { "puppet-repo" }
    # Match any .rb file (but be carefull not include and dot-temporary files)
    watch(%r{^puppet-repo/.*/[^.]*\.rb$}) { "puppet-repo" }
    # Match any _rspec.rb file (but be carefull not include and dot-temporary files)
    watch(%r{^puppet-repo/.*/[^.]*_rspec.rb})
  end

  # Run cucumber puppet tests
  # This uses out extended cucumber guard, as by default it only looks in the features directory
  # --strict        : because otherwise cucumber would exit with 0 when there are pending steps
  # --format pretty : to get readable output, default is null output
  guard :cucumber, :feature_sets => ["puppet-repo/features"], :cli => "-s --require puppet-repo/features --strict --format pretty" do

    # Match any .pp file (but be carefull not include and dot-temporary files)
    watch(%r{^puppet-repo/[^.]*\.pp$}) { "puppet-repo/features" }

    # Match any .rb file (but be carefull not include and dot-temporary files)
    watch(%r{^puppet-repo/[^.]*\.rb$}) { "puppet-repo/features" }

    # Feature files are monitored as well
    watch(%r{^puppet-repo/features/[^.]*.feature})

    # This is only invoked on changes, not at initial startup
    callback(:start_end) do
      vagrant_provision if all_tests_pass
    end
    callback(:run_on_change_end) do
      vagrant_provision if all_tests_pass
    end
  end
end

group :vm_tests do
  # Run cucumber tests on the VM(s)
  guard :cucumber, :cli => "-s --strict --format pretty" do
    # Match any .rb file (but be careful not include and dot-temporary files)
    watch(%r{^features/[^.]*\.rb$}) { "features" }

    # Feature files are monitored as well
    watch(%r{^features/[^.]*.feature})
    
    # Watch to see if the VM(s) have been reprovisioned
    watch('.vagrant_last_provisioned')
  end
end

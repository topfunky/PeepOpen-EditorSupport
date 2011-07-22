#!/usr/bin/env ruby

require 'FileUtils'

source = File.expand_path("PeepOpen.applescript", File.dirname(__FILE__))

# Copy to all application support directories in use
%w(~/Dropbox ~/Library).each do |root|
    %w(BBEdit TextWrangler).each do |app|
        target_root = File.join(File.expand_path(root), "Application Support", app, "Scripts")
        
        if File.directory?(target_root)
            target = File.join(target_root, "PeepOpen.applescript")
            puts "Installing to #{target}"
            FileUtils.cp(source, target)
        end
    end
end

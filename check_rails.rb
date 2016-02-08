# check we're connected to Rails
if defined?(Rails).nil?
  abort "You need to run this script via `rails runner`!"
end

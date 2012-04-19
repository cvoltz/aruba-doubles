require 'tempfile'
require 'aruba-doubles/double'

module ArubaDoubles
  def double_cmd(cmd, output = {})
   # Double.create(cmd) do
   #   on [], output
   # end

   argv = Shellwords.split(cmd)
   d = Double.new(argv.shift)
   d.on(argv, output)
   d.create
  end
end

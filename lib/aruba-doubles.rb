require 'tempfile'
require 'shellwords'
require 'aruba-doubles/double'

module ArubaDoubles
  def double_cmd(cmd, output = {})
   argv = Shellwords.split(cmd)
   Double.create(argv.shift) do
     on(argv, output)
   end
  end
end

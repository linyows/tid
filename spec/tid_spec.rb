RSpec.describe 'Tid' do
  describe 'ssh to docker container' do
    let(:ssh_to_docker_container) do
      [
        "ssh root@#{ENV['TID_HOSTNAME']}",
        "-p #{ENV['TID_PORT']}",
        "-i #{ENV['TID_BASE_PATH']}/id_rsa",
        "-o StrictHostKeyChecking=no",
        "-o UserKnownHostsFile=/dev/null",
        "'echo yo'"
      ].join(' ')
    end

    it 'successful' do
      _, _, ex = cmd ssh_to_docker_container
      expect(ex.exitstatus).to eq 0
    end

    it 'puts yo' do
      out, _, _ = cmd ssh_to_docker_container
      expect(out).to eq "yo\n"
    end
  end
end

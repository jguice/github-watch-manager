require 'github_watch_manager'

RSpec.describe GithubWatchManager do
  let(:gwm) { described_class.new }

  describe '#get_token' do
    context 'when token is missing' do
      it { expect(gwm.get_token(nil)).to be(nil) }
    end

    context 'when the token file is present' do
      it { expect(gwm.get_token("#{fixtures}/good.token")).to eq('6ceeaaf2f4c03097ea0be1264565ed2493d4b25c') }
      it { expect(gwm.get_token("#{fixtures}/bad.token")).not_to eq('6ceeaaf2f4c03097ea0be1264565ed2493d4b25c') }
    end
  end

  describe '#show_intro' do
    it { expect { gwm.show_intro }.to output(/github/).to_stdout }
  end

  describe '#prompt_for_credentials' do
    # TODO figure out how to do this in a way that assumes no knowledge of *how* STDIN is read (e.g. no
    # STDIN.should_receive(:gets))
    it 'should prompt for username and read an <enter> terminated string from STDIN'
  end

  describe '#create_and_save_app_token' do
    it 'should create a github application token, prompting for a 2FA token first if required'
  end

  describe '#create_github_client' do
    it 'should create a client object for interaction with the github API'
  end

  # TODO re-evaluate approach to github client creation...right now we make one internally in GWM and tweak the
  # middleware to raise an exception that allows us to handle the 2FA case (which BTW is a silly bunch of hoops).  Then
  # we create a separate one directly in gwm.  It really should just be the one client.  Maybe if we store the initial
  # middleware we can put it back after the 2FA dance and continue to use the one client (which GWM would retain a
  # reference to).  This would allow creation of the methods below using the GWM "internal" client instead of doing any
  # of that in gwm. :)

  # describe '#watch_repo' do
  #   context 'when repo is valid' do
  #     it 'sets subscribed => true and ignored => false'
  #   end

  #   context 'when repo is invalid' do
  #     it 'returns a helpful message/exception'
  #   end
  # end

  # describe '#unwatch_repo' do
  #   context 'when repo is valid' do
  #     it 'sets subscribed => false and ignored => true'
  #   end

  #   context 'when repo is invalid' do
  #     it 'returns a helpful message/exception'
  #   end
  # end
end

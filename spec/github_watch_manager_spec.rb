require 'github_watch_manager'

RSpec.describe GithubWatchManager do
  let(:gwm) { described_class.new }

  describe '.get_token' do
    context 'when token is missing' do
      it { expect(gwm.get_token).to be(nil) }
    end

    context 'when the token file is present' do
      it { expect(gwm.get_token("#{fixtures}/good.token")).to eq('6ceeaaf2f4c03097ea0be1264565ed2493d4b25c') }
      it { expect(gwm.get_token("#{fixtures}/bad.token")).not_to eq('6ceeaaf2f4c03097ea0be1264565ed2493d4b25c') }
    end
  end

  describe '.show_intro' do
    it { expect{ gwm.show_intro }.to output(/github/).to_stdout }
  end
end

# describe SimpleController do

#   before(:each) do
#     @controller = SimpleController.new()
#   end

#   describe '#initialize' do
#     it 'returns a properly initialized SimpleController instance' do
#       expect(@controller.class.to_s).to eq 'SimpleController'
#     end

#     it 'has a read/write params attribute' do
#       @controller.params[:foo] = 'bar'

#       expect(@controller.params[:foo]).to eq 'bar'
#     end

#     it 'has a read/write messages attribute' do
#       @controller.messages[:error] = 'DANGER'

#       expect(@controller.messages[:error]).to eq 'DANGER'

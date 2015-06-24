require 'github-watch-manager'

RSpec.describe GithubWatchManager do

  before(:each) do
    @manager = GithubWatchManager.new()
  end

  describe '.get_token' do

    context 'when token is missing' do
      it { expect(@manager.get_token).to be(nil) }
    end

    context 'when the token file is present' do
      it { expect(@manager.get_token("#{fixtures}/good.token")).to eq('6ceeaaf2f4c03097ea0be1264565ed2493d4b25c') }
      it { expect(@manager.get_token("#{fixtures}/bad.token")).not_to eq('6ceeaaf2f4c03097ea0be1264565ed2493d4b25c')}
    end

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

require 'util'

include Util

RSpec.describe Util do
  describe 'listify' do
    context 'when list is nil' do
      it { expect(listify(nil)).to eq(nil) }
    end

    context 'when list size is one' do
      it { expect(listify(%w(foo))).to eq('foo') }
    end

    context 'when list size is two' do
      it { expect(listify(%w(alpha beta))).to eq('alpha and beta') }
    end

    context 'when list is a valid list-like object' do
      it { expect(listify(%w(one two three))).to eq('one, two, and three') }
      it { expect(listify('c' => 300, 'a' => 100, 'd' => 400, 'c' => 300)).to eq('c, 300, a, 100, d, and 400') }
    end

    context 'when list is not a list-like object' do
      it { expect { listify('Hi Mom!') }.to raise_exception(ArgumentError) }
    end
  # describe '.get_token' do
  #   context 'when token is missing' do
  #     it { expect(manager.get_token).to be(nil) }
  #   end

  #   context 'when the token file is present' do
  #     it { expect(manager.get_token("#{fixtures}/good.token")).to eq('6ceeaaf2f4c03097ea0be1264565ed2493d4b25c') }
  #     it { expect(manager.get_token("#{fixtures}/bad.token")).not_to eq('6ceeaaf2f4c03097ea0be1264565ed2493d4b25c') }
  #   end
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

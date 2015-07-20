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
  end

  describe 'parse_options' do
    it 'should parse options correctly'
  end
end

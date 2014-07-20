require 'spec_helper'

describe(Jekyll::LastModifiedAt::Executor) do
  it "gets and strips the output" do
    expect(described_class.sh('echo', 'ohai')).to eql('ohai')
  end
end

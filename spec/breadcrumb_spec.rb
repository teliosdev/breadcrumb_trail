RSpec.describe BreadcrumbTrail::Breadcrumb do
  let(:name) { nil }
  let(:path) { nil }
  let(:options) { {} }
  let(:block) { nil }
  let(:context) { double("context") }
  subject { described_class.new(name: name, path: path, **options, &block) }

  describe "when given string name and path" do
    let(:name) { "Home" }
    let(:path) { "/" }

    it "returns the string name" do
      expect(subject.computed_name(context)).to eq name
    end

    it "returns the string path" do
      expect(subject.computed_path(context)).to eq path
    end
  end

  describe "when given symbol name and path" do
    let(:name) { :some_name }
    let(:path) { :root_path }

    let(:actual_name) { "Home" }
    let(:actual_path) { "/" }

    it "returns the called name" do
      expect(context).to receive(:some_name).once.and_return(actual_name)
      expect(subject.computed_name(context)).to be actual_name
    end

    it "returns the called path" do
      expect(context).to receive(:root_path).once.and_return(actual_path)
      expect(subject.computed_path(context)).to be actual_path
    end
  end

  describe "when given a nil name and a path hash" do
    let(:path) { { controller: "home" } }

    it "returns the hash path for name" do
      expect(subject.computed_name(context)).to be path
    end

    it "returns the hash path" do
      expect(subject.computed_path(context)).to be path
    end
  end

  describe "when given a name block and a path block" do
    let(:name) { proc { hello_name } }
    let(:path) { proc { hello_path } }

    let(:actual_name) { "Home" }
    let(:actual_path) { "/" }

    it "returns the result of the name block" do
      expect(context).to receive(:hello_name).once.and_return(actual_name)
      expect(subject.computed_name(context)).to be actual_name
    end

    it "returns the result of the path block" do
      expect(context).to receive(:hello_path).once.and_return(actual_path)
      expect(subject.computed_path(context)).to be actual_path
    end
  end

  describe "when given a name, no path, and a block" do
    let(:name) { "Home" }
    let(:block) { proc { root_path } }

    let(:actual_path) { "/" }

    it "returns the result of the block" do
      expect(context).to receive(:root_path).once.and_return(actual_path)
      expect(subject.computed_path(context)).to be actual_path
    end
  end

  describe "when given a bad name and a bad path" do
    let(:name) { Object.new }
    let(:path) { Object.new }

    it "raises an error" do
      expect { subject.computed_path(context) }.
        to raise_error(ArgumentError)
      expect { subject.computed_name(context) }.
        to raise_error(ArgumentError)
    end
  end
end

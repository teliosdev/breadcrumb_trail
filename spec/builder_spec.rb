RSpec.describe BreadcrumbTrail::Builder do
  let(:breadcrumbs) {
    [
      { path: "/", name: "home" },
      { path: "/foo", name: "foo" },
      { path: "/foo/bar", name: "foo/bar" }
    ].map { |data| BreadcrumbTrail::Breadcrumb.new(data) } }
  let(:context) { double("context") }

  subject { described_class.new(context, breadcrumbs) }

  it "raises on call" do
    expect { subject.call }.to raise_error(NotImplementedError)
  end
end


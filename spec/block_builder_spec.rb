RSpec.describe BreadcrumbTrail::BlockBuilder do
  let(:breadcrumbs) {
    [
      { path: "/", name: "home" },
      { path: "/foo", name: "foo" },
      { path: "/foo/bar", name: "foo/bar" }
    ].map { |data| BreadcrumbTrail::Breadcrumb.new(data) } }
  let(:context) { double("context") }
  let(:block) { proc { |element| %Q(<a href="#{element.path}">#{element.name}</a>).html_safe } }

  subject { described_class.new(context, breadcrumbs, &block) }

  it "renders a list" do
    expect(subject.call).to eq \
        "<a href=\"/\">home</a>" \
        "<a href=\"/foo\">foo</a>" \
        "<a href=\"/foo/bar\">foo/bar</a>"
  end
end

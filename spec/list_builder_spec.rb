RSpec.describe BreadcrumbTrail::ListBuilder do
  let(:breadcrumbs) {
    [
      { path: "/", name: "home" },
      { path: "/foo", name: "foo" },
      { path: "/foo/bar", name: "foo/bar" }
    ].map { |data| BreadcrumbTrail::Breadcrumb.new(data) } }
  let(:context) { double("context") }

  subject { described_class.new(context, breadcrumbs) }

  it "renders a list" do
    expect(subject.call).to eq "<ol>" \
      "<li><a href=\"/\">home</a></li>" \
      "<li><a href=\"/foo\">foo</a></li>" \
      "<li><a href=\"/foo/bar\">foo/bar</a></li>" \
      "</ol>"
  end

  describe "when given breadcrumbs with html data" do
    let(:breadcrumbs) {
      [
        { path: "/", name: "<script>home</script>" },
        { path: "/foo", name: "<a>foo</a>" },
        { path: "/foo/bar", name: "<foo/bar>" }
      ].map { |data| BreadcrumbTrail::Breadcrumb.new(data) }
    }

    it "escapes the breadcrumbs" do
      expect(subject.call).to eq "<ol>" \
        "<li><a href=\"/\">&lt;script&gt;home&lt;/script&gt;</a></li>" \
        "<li><a href=\"/foo\">&lt;a&gt;foo&lt;/a&gt;</a></li>" \
        "<li><a href=\"/foo/bar\">&lt;foo/bar&gt;</a></li>" \
        "</ol>"
    end
  end
end

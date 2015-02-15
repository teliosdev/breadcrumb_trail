describe "Application request", type: :request do
  example "A home request" do
    get '/'

    expect(response.body).to eq <<-HTML.strip_heredoc
      <!DOCTYPE html>
      <html>
      <head>
        <title>Dummy app</title>
      </head>
      <body>
      <ol><li><a href="/">home</a></li><li><a href="/">here</a></li></ol>
      <h1>Home</h1>
      <p>Hello world!</p>


      </body>
      </html>
    HTML
  end
end

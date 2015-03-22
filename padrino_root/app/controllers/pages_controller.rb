# Adds routes to root controller namespace, not nested under /pages
PadrinoTestTemplate::App.controllers do
  get :index do
    render 'pages/index'
  end
end

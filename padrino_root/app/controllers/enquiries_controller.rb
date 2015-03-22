# PadrinoTestTemplate::App.controllers :enquiries do
#   params_permitted = [:authenticity_token]

#   post :index, params: PadrinoTestTemplate::App::Enquiry.params.concat(params_permitted) do
#     enquiry = PadrinoTestTemplate::App::Enquiry.new(params)
#     enquiry.save
#     enquiry.status_code
#   end
# end

Capybara.javascript_driver = :webkit
Capybara::Webkit.configure do |config|
  config.allow_url("https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700")
end
Capybara.default_max_wait_time = 60

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

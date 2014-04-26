#if Rails.env.production?
  SUBURI = ''
  #set session timeout minutes
  SESSION_TIMEOUT_MINUTES = 90
  SESSION_WIPEOUT_HOURS = 12
 
  BUTTONS_CLS = {'default' => 'btn',
                 'action'       => 'btn btn-primary' }



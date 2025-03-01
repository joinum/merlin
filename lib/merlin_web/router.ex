defmodule MerlinWeb.Router do
  use MerlinWeb, :router

  import MerlinWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MerlinWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MerlinWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/register/:qr", UserRegistrationController, :new
    post "/register/:qr", UserRegistrationController, :create
    get "/", UserSessionController, :new
    post "/", UserSessionController, :create
    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
    get "/reset_password", UserResetPasswordController, :new
    post "/reset_password", UserResetPasswordController, :create
    get "/reset_password/:token", UserResetPasswordController, :edit
    put "/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", MerlinWeb do
    pipe_through [:browser]

    live_session :user, on_mount: [{MerlinWeb.Hooks, :current_user}] do

      scope "/", App do
        live "/profile/:qr", ProfileLive.Show, :qr_show
      end
    end
  end

  scope "/", MerlinWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :logged_in, on_mount: [{MerlinWeb.Hooks, :current_user}] do
      scope "/app", App do
        live "/", DashboardLive.Index, :index

        live "/dashboard/curriculum", DashboardLive.Edit, :edit

        live "/curriculum", CurriculumLive.Index, :index

        live "/offers/", OfferLive.Index, :index
        live "/offers/new", OfferLive.New, :new
        live "/offers/:id", OfferLive.Show, :show
        live "/offers/:id/edit", OfferLive.Edit, :edit

        live "/companies/", CompanyLive.Index, :index
        live "/companies/new", CompanyLive.New, :new
        live "/companies/:id", CompanyLive.Show, :show
        live "/companies/:id/edit", CompanyLive.Edit, :edit

        live "/announcements", AnnouncementLive.Index, :index
        live "/announcements/:id", AnnouncementLive.Show, :show

        live "/connections", ConnectionLive.Index, :index

        live "/profile/:id", ProfileLive.Show, :show
        live "/profile/:id/edit", ProfileLive.Edit, :edit
      end

      scope "/admin", Backoffice, as: :admin do
        live "/accounts/", UserLive.Index, :index
        live "/accounts/new", UserLive.New, :new

        scope "/jobs" do
          live "/types/", OfferTypeLive.Index, :index
          live "/types/new", OfferTypeLive.Index, :new
          live "/types/:id/edit", OfferTypeLive.Index, :edit

          live "/times/", OfferTimeLive.Index, :index
          live "/times/new", OfferTimeLive.Index, :new
          live "/times/:id/edit", OfferTimeLive.Index, :edit
        end

        scope "/companies" do
          live "/levels/", LevelLive.Index, :index
          live "/levels/new", LevelLive.Index, :new
          live "/levels/:id/edit", LevelLive.Index, :edit
        end

        scope "/tools" do

          live "/announcements/new", AnnouncementLive.New, :new
          live "/announcements/:id/edit", AnnouncementLive.Edit, :edit

          live "/scanner", ScannerLive.Index, :index
        end
      end
    end

    get "/settings", UserSettingsController, :edit
    put "/settings", UserSettingsController, :update
    get "/settings/confirm_email/:token", UserSettingsController, :confirm_email
    get "/cv/:attendee_id", PdfController, :download_cv
    get "/cv/preview", PdfController, :preview_cv
  end

  scope "/", MerlinWeb do
    pipe_through [:browser]

    delete "/log_out", UserSessionController, :delete
    get "/confirm", UserConfirmationController, :new
    post "/confirm", UserConfirmationController, :create
    get "/confirm/:token", UserConfirmationController, :edit
    post "/confirm/:token", UserConfirmationController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", MerlinWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MerlinWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

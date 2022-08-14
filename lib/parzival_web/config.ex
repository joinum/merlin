defmodule ParzivalWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias ParzivalWeb.Router.Helpers, as: Routes

  @conn ParzivalWeb.Endpoint

  def pages(conn, current_user) do
    live_pages(conn) ++ role_pages(conn, current_user)
  end

  def role_pages(conn, user) do
    case user.role do
      :admin -> admin_pages(conn)
      :attendee -> attendee_pages(conn)
      :recruiter -> recruiter_pages(conn, user.company)
      :staff -> admin_pages(conn)
    end
  end

  defp live_pages(conn) do
    [
      %{
        key: :dashboard,
        title: "Dashboard",
        url: Routes.dashboard_index_path(conn, :index),
        tabs: []
      }
    ]
  end

  def attendee_pages(conn) do
    [
      %{
        key: :jobs,
        title: "Jobs",
        url: Routes.offer_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :companies,
        title: "Companies",
        url: Routes.company_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :announcements,
        title: "Announcements",
        url: Routes.announcement_index_path(conn, :index),
        tabs: []
      }
    ]
  end

  def recruiter_pages(conn, user) do
    [
      %{
        key: :jobs,
        title: "Jobs",
        url: Routes.offer_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :connections,
        title: "Connections",
        url: Routes.connection_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :companies,
        title: "Company",
        url: Routes.company_show_path(conn, :show, user),
        tabs: []
      },
      %{
        key: :announcements,
        title: "Announcements",
        url: Routes.announcement_index_path(conn, :index),
        tabs: []
      }
    ]
  end

  def admin_pages(conn) do
    [
      %{
        key: :jobs,
        title: "Jobs",
        url: Routes.offer_index_path(conn, :index),
        tabs: [
          %{
            key: :jobs,
            title: "Offers",
            url: Routes.offer_index_path(conn, :index)
          },
          %{
            key: :jobs,
            title: "Types",
            url: Routes.admin_offer_type_index_path(conn, :index)
          },
          %{
            key: :jobs,
            title: "Times",
            url: Routes.admin_offer_time_index_path(conn, :index)
          }
        ]
      },
      %{
        key: :companies,
        title: "Sponsors",
        url: Routes.company_index_path(conn, :index),
        tabs: [
          %{
            key: :companies,
            title: "Companies",
            url: Routes.company_index_path(conn, :index)
          },
          %{
            key: :levels,
            title: "Levels",
            url: Routes.admin_level_index_path(conn, :index)
          }
        ]
      },
      %{
        key: :accounts,
        title: "Accounts",
        url:
          Routes.admin_user_index_path(conn, :index, %{
            "filters" => %{"0" => %{"field" => "role", "value" => "attendee"}}
          }),
        tabs: [
          %{
            key: :student,
            title: "Attendees",
            url:
              Routes.admin_user_index_path(conn, :index, %{
                "filters" => %{"0" => %{"field" => "role", "value" => "attendee"}}
              })
          },
          %{
            key: :admin,
            title: "Admins",
            url:
              Routes.admin_user_index_path(conn, :index, %{
                "filters" => %{"0" => %{"field" => "role", "value" => "admin"}}
              })
          },
          %{
            key: :staff,
            title: "Staff",
            url:
              Routes.admin_user_index_path(conn, :index, %{
                "filters" => %{"0" => %{"field" => "role", "value" => "staff"}}
              })
          },
          %{
            key: :recruiter,
            title: "Recruiters",
            url:
              Routes.admin_user_index_path(conn, :index, %{
                "filters" => %{"0" => %{"field" => "role", "value" => "recruiter"}}
              })
          }
        ]
      },
      %{
        key: :tools,
        title: "Tools",
        url: Routes.admin_faqs_index_path(conn, :index),
        tabs: [
          %{
            key: :announcements,
            title: "Announcements",
            url: Routes.announcement_index_path(conn, :index)
          }
        ]
      }
    ]
  end
end

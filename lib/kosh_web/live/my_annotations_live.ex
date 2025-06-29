defmodule KoshWeb.MyAnnotationsLive do
  use KoshWeb, :live_view
  import KoshWeb.Components.DescriptionAnnotationCard
  import KoshWeb.Components.SubjectAnnotationCard

  alias Kosh.Annotations

  def mount(_params, _session, socket) do
    {submitted_subjects, submitted_descriptions} = {
      Annotations.list_subject_annotations_of_user(socket.assigns.current_user.id, :pending),
      Annotations.list_description_annotations_of_user(socket.assigns.current_user.id, :pending)
    }

    {approved_subjects, approved_descriptions} = {
      Annotations.list_subject_annotations_of_user(socket.assigns.current_user.id, :accepted),
      Annotations.list_description_annotations_of_user(socket.assigns.current_user.id, :accepted)
    }

    # IO.inspect(submitted_subjects, label: "submitted_subjects")
    # IO.inspect(submitted_descriptions)

    socket =
      socket
      |> assign(:submitted_subjects, submitted_subjects)
      |> assign(:submitted_descriptions, submitted_descriptions)
      |> assign(:approved_subjects, approved_subjects)
      |> assign(:approved_descriptions, approved_descriptions)

    {:ok, socket}
  end

  def handle_event("delete_description", %{"id" => id}, socket) do
    case Annotations.delete_description_annotation(id) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Description annotation deleted")
          |> push_navigate(to: "/annotation/my-annotations")

        {:noreply, socket}

      {:error, :not_found} ->
        socket = socket |> put_flash(:error, "Description annotation not found")
        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(
            :error,
            "Failed to delete description annotation: #{inspect(changeset.errors)}"
          )

        {:noreply, socket}
    end
  end

  def handle_event("delete_subject", %{"id" => id}, socket) do
    case Annotations.delete_subject_annotation(id) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Subject annotation deleted")
          |> push_navigate(to: "/annotation/my-annotations")

        {:noreply, socket}

      {:error, :not_found} ->
        socket = socket |> put_flash(:error, "Subject annotation not found")
        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(
            :error,
            "Failed to delete subject annotation: #{inspect(changeset.errors)}"
          )

        {:noreply, socket}

      _ ->
        socket =
          socket |> put_flash(:info, "Something went wrong while deleting subject annotation")

        {:noreply, socket}
    end
  end
end

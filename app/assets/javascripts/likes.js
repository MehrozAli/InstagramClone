$(function() {
  $(".like-icon").on('click', (e) => {
    let post_id = $(e.target).data("id");

    $.ajax({
      url: `/posts/${post_id}/like`,
      method: "GET",
    })
  })
})

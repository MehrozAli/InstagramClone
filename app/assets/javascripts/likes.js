$(function() {
  $(".like-icon").on('click', (e) => {
    let post_id = $(e.target).data("id");

    $.ajax({
      url: `/post/like/${post_id}`,
      method: "GET",
    })
  })
})

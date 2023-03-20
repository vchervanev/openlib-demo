document.querySelector('#search-form').addEventListener('submit', async function(e){
  e.preventDefault();
  const title = document.querySelector('#search-title').value
  const response = await fetch(`/search?title=${encodeURIComponent(title)}`)
  const data = await response.json()

  if (data.success != true) {
    alert(data.error || 'Unable to load data')
    return
  }

  let html = ''

  data.payload.forEach(rec => {
    html += `
      <tr>
        <td>${rec.title}</td>
        <td>${rec.authors}</td>
        <td><a href="${rec.link}">Go to Book Page</a></td>
      </tr>
    `
  });

  document.querySelector('tbody#search-result').innerHTML = html
});
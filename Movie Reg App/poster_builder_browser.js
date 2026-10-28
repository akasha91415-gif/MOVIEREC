// MOVIEREC poster builder - runs in your BROWSER (not R).
// 1) Open https://api.themoviedb.org/3/configuration?api_key=YOUR_KEY in Firefox/Chrome
// 2) Press F12 -> Console. If asked, type:  allow pasting   and press Enter
// 3) Paste this whole script, press Enter, and enter your TMDB API key when asked.
// 4) A file poster_cache.csv downloads. Put it in the same folder as app.R, restart the app.
(async () => {
  const KEY = (prompt("Paste your TMDB API key") || "").trim();
  if (!KEY) { alert("No key entered."); return; }
  const MOVIES = [{"t":"Paruthiveeran","y":2007},{"t":"Polladhavan","y":2007},{"t":"Chennai 600028","y":2007},{"t":"Mozhi","y":2007},{"t":"Sivaji","y":2007},{"t":"Vaaranam Aayiram","y":2008},{"t":"Subramaniapuram","y":2008},{"t":"Dasavathaaram","y":2008},{"t":"Ayan","y":2009},{"t":"Pasanga","y":2009},{"t":"Naadodigal","y":2009},{"t":"Paiyaa","y":2010},{"t":"Vinnaithaandi Varuvaayaa","y":2010},{"t":"Madrasapattinam","y":2010},{"t":"Enthiran","y":2010},{"t":"Ko","y":2011},{"t":"Aaranya Kaandam","y":2011},{"t":"Mankatha","y":2011},{"t":"Deiva Thirumagal","y":2011},{"t":"Aadukalam","y":2011},{"t":"Engeyum Eppodhum","y":2011},{"t":"Naan Ee","y":2012},{"t":"Pizza","y":2012},{"t":"Vazhakku Enn 18/9","y":2012},{"t":"Thuppakki","y":2012},{"t":"Soodhu Kavvum","y":2013},{"t":"Raja Rani","y":2013},{"t":"Arrambam","y":2013},{"t":"Jigarthanda","y":2014},{"t":"Madras","y":2014},{"t":"Kaaviya Thalaivan","y":2014},{"t":"Kaththi","y":2014},{"t":"I","y":2015},{"t":"Papanasam","y":2015},{"t":"OK Kanmani","y":2015},{"t":"Indru Netru Naalai","y":2015},{"t":"Thani Oruvan","y":2015},{"t":"Irudhi Suttru","y":2016},{"t":"Dhuruvangal Pathinaaru","y":2016},{"t":"Kabali","y":2016},{"t":"Aandavan Kattalai","y":2016},{"t":"Uriyadi","y":2016},{"t":"Iraivi","y":2016},{"t":"Joker","y":2016},{"t":"Aruvi","y":2016},{"t":"Vikram Vedha","y":2017},{"t":"Theeran Adhigaaram Ondru","y":2017},{"t":"Mersal","y":2017},{"t":"Arjun Reddy Tamil Dub","y":2017},{"t":"Maanagaram","y":2017},{"t":"Meyaadha Maan","y":2017},{"t":"96","y":2018},{"t":"Ratsasan","y":2018},{"t":"Vada Chennai","y":2018},{"t":"Pariyerum Perumal","y":2018},{"t":"Kaala","y":2018},{"t":"2.0","y":2018},{"t":"Merku Thodarchi Malai","y":2018},{"t":"Super Deluxe","y":2019},{"t":"Asuran","y":2019},{"t":"Kaithi","y":2019},{"t":"Petta","y":2019},{"t":"Comali","y":2019},{"t":"To Let","y":2019},{"t":"Soorarai Pottru","y":2020},{"t":"Kannum Kannum Kollaiyadithaal","y":2020},{"t":"Oh My Kadavule","y":2020},{"t":"Nasir","y":2020},{"t":"Master","y":2021},{"t":"Jai Bhim","y":2021},{"t":"Doctor","y":2021},{"t":"Maanaadu","y":2021},{"t":"Sarpatta Parambarai","y":2021},{"t":"Karnan","y":2021},{"t":"Mandela","y":2021},{"t":"Nenjam Marappathillai","y":2021},{"t":"Koozhangal","y":2021},{"t":"Seththumaan","y":2021},{"t":"Don","y":2022},{"t":"Vikram","y":2022},{"t":"Thiruchitrambalam","y":2022},{"t":"Ponniyin Selvan: Part I","y":2022},{"t":"Nenjuku Needhi","y":2022},{"t":"Love Today","y":2022},{"t":"Gargi","y":2022},{"t":"Vendhu Thanindhathu Kaadu","y":2022},{"t":"Kadaisi Vivasayi","y":2022},{"t":"Viduthalai Part 1","y":2023},{"t":"Maamannan","y":2023},{"t":"Por Thozhil","y":2023},{"t":"Good Night","y":2023},{"t":"Mark Antony","y":2023},{"t":"Jailer","y":2023},{"t":"Leo","y":2023},{"t":"Chithha","y":2023},{"t":"Parking","y":2023},{"t":"Dada","y":2023},{"t":"Blue Star","y":2024},{"t":"Aranmanai 4","y":2024},{"t":"Maharaja","y":2024},{"t":"Garudan","y":2024},{"t":"Lubber Pandhu","y":2024},{"t":"Meiyazhagan","y":2024},{"t":"Amaran","y":2024},{"t":"Kanguva","y":2024},{"t":"Raayan","y":2024},{"t":"GOAT","y":2024},{"t":"Brother","y":2024},{"t":"Dragon","y":2025},{"t":"Tourist Family","y":2025},{"t":"Good Bad Ugly","y":2025},{"t":"Retro","y":2025},{"t":"Thug Life","y":2025},{"t":"Coolie","y":2025},{"t":"Vidaamuyarchi","y":2025},{"t":"Kuberaa","y":2025},{"t":"Veera Dheera Sooran","y":2025},{"t":"Suriya 45","y":2025},{"t":"Parasakthi","y":2026},{"t":"Vaa Vaathiyaar","y":2026}];
  const norm = s => (s || "").toLowerCase().replace(/[^a-z0-9]/g, "");
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  const rows = [["title", "poster_url"]];
  const unmatched = [];
  let failures = 0;
  for (let i = 0; i < MOVIES.length; i++) {
    const m = MOVIES[i];
    const url = "https://api.themoviedb.org/3/search/movie?api_key=" + KEY +
      "&query=" + encodeURIComponent(m.t) + "&include_adult=false";
    try {
      let res = await fetch(url);
      if (res.status === 429) { await sleep(5000); res = await fetch(url); }
      if (!res.ok) throw new Error("HTTP " + res.status);
      const data = await res.json();
      failures = 0;
      const cand = (data.results || []).filter(r => r.poster_path);
      // STRICT: only Tamil-language films are accepted (avoids same-name films such as
      // the 2023 animated "Leo" or the 2022 English "Beast"). Best match first.
      const score = r => {
        const yr = parseInt((r.release_date || "").slice(0, 4), 10);
        const yearOk = !isNaN(yr) && Math.abs(yr - m.y) <= 1;
        const titleOk = norm(r.title) === norm(m.t) || norm(r.original_title) === norm(m.t);
        if (r.original_language !== "ta") return 0;
        return (yearOk ? 2 : 0) + (titleOk ? 2 : 0) + (yearOk && titleOk ? 1 : 0);
      };
      const ranked = cand.map(r => ({ r, sc: score(r) })).filter(x => x.sc >= 2).sort((a, b) => b.sc - a.sc);
      const good = ranked.length ? ranked[0].r : null;
      if (good) {
        rows.push([m.t, "https://image.tmdb.org/t/p/w500" + good.poster_path]);
        console.log("[" + (i + 1) + "/120] OK  " + m.t + " -> " + good.title + " (" + (good.release_date || "").slice(0, 4) + ")");
      } else {
        unmatched.push(m.t);
        console.warn("[" + (i + 1) + "/120] NO CONFIDENT MATCH: " + m.t);
      }
    } catch (e) {
      failures++;
      unmatched.push(m.t);
      console.error("Error on " + m.t + ": " + e.message);
      if (failures >= 3) { alert("3 errors in a row - stopping. Check your key/connection and run again."); break; }
      await sleep(3000);
    }
    await sleep(350);
  }
  const csv = rows.map(r => r.map(v => '"' + String(v).replace(/"/g, '""') + '"').join(",")).join("\n");
  const a = document.createElement("a");
  a.href = URL.createObjectURL(new Blob([csv], { type: "text/csv" }));
  a.download = "poster_cache.csv";
  document.body.appendChild(a); a.click(); a.remove();
  console.log("Matched: " + (rows.length - 1) + " | Not matched: " + unmatched.length);
  if (unmatched.length) console.log("Not matched:\n" + unmatched.join("\n"));
  alert("Done. Matched " + (rows.length - 1) + " of 120. File poster_cache.csv was downloaded.\nNot matched: " + unmatched.length + " (listed in the Console).");
})();

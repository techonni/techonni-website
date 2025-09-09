(function () {
  const storageKey = 'theme';

  function getSavedTheme() {
    const t = localStorage.getItem(storageKey);
    if (t === 'light' || t === 'dark') return t;
    return null;
  }

  function systemPrefersDark() {
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  }

  function getPreferredTheme() {
    const saved = getSavedTheme();
    if (saved) return saved;
    return systemPrefersDark() ? 'dark' : 'light';
  }

  function applyTheme(theme) {
    document.body.classList.toggle('dark', theme === 'dark');
    const btn = document.getElementById('t-toggle');
    if (btn) btn.textContent = theme === 'dark' ? '☀️' : '☾';
  }

  function init() {
    applyTheme(getPreferredTheme());

    const btn = document.getElementById('t-toggle');
    if (btn) {
      btn.addEventListener('click', function () {
        const next = document.body.classList.contains('dark') ? 'light' : 'dark';
        localStorage.setItem(storageKey, next);
        applyTheme(next);
      });
    }

    const mq = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)');
    if (mq) {
      const onChange = (e) => {
        if (!getSavedTheme()) {
          applyTheme(e.matches ? 'dark' : 'light');
        }
      };
      if (mq.addEventListener) mq.addEventListener('change', onChange);
      else if (mq.addListener) mq.addListener(onChange);
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();

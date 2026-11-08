/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        bg: 'var(--color-bg)',
        surface: 'var(--color-surface)',
        border: 'var(--color-border)',
        'border-input': 'var(--color-border-input)',
        text: 'var(--color-text)',
        'text-muted': 'var(--color-text-muted)',
        accent: 'var(--color-accent)',
        'accent-light': 'var(--color-accent-light)',
        'accent-dark': 'var(--color-accent-dark)',
        'on-accent': 'var(--color-on-accent)',
        danger: 'var(--color-danger)',
        'on-danger': 'var(--color-on-danger)',
        success: 'var(--color-success)',
        'on-success': 'var(--color-on-success)',
        warning: 'var(--color-warning)',
        'on-warning': 'var(--color-on-warning)',
        overlay: 'var(--color-overlay)',
      },
      fontFamily: {
        sans: ['var(--font-sans)', 'system-ui', 'sans-serif'],
        mono: ['var(--font-mono)', 'monospace'],
      },
      fontSize: {
        xs: ['var(--size-xs)', { lineHeight: 'var(--line-xs)', fontWeight: 'var(--weight-xs)' }],
        sm: ['var(--size-sm)', { lineHeight: 'var(--line-sm)', fontWeight: 'var(--weight-sm)' }],
        base: ['var(--size-base)', { lineHeight: 'var(--line-base)', fontWeight: 'var(--weight-base)' }],
        lg: ['var(--size-lg)', { lineHeight: 'var(--line-lg)', fontWeight: 'var(--weight-lg)' }],
        xl: ['var(--size-xl)', { lineHeight: 'var(--line-xl)', fontWeight: 'var(--weight-xl)' }],
        display: ['var(--size-display)', { lineHeight: 'var(--line-display)', fontWeight: 'var(--weight-display)' }],
      },
      spacing: {
        0: 'var(--space-0)',
        1: 'var(--space-1)',
        2: 'var(--space-2)',
        3: 'var(--space-3)',
        4: 'var(--space-4)',
        5: 'var(--space-5)',
        6: 'var(--space-6)',
        7: 'var(--space-7)',
        8: 'var(--space-8)',
      },
      borderRadius: {
        sm: 'var(--radius-sm)',
        md: 'var(--radius-md)',
        lg: 'var(--radius-lg)',
        pill: 'var(--radius-pill)',
      },
      boxShadow: {
        card: 'var(--shadow-card)',
        pop: 'var(--shadow-pop)',
        modal: 'var(--shadow-modal)',
      },
      transitionTimingFunction: {
        ease: 'var(--ease)',
      },
      transitionDuration: {
        fast: 'var(--motion-fast)',
        base: 'var(--motion-base)',
      },
    },
  },
  plugins: [],
}
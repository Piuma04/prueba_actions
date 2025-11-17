import { test, expect } from '@playwright/test';

test('counter increments when button is clicked', async ({ page }) => {
  // Change the URL if your dev server runs on a different port
  await page.goto('http://localhost:5173/');

  const button = page.getByRole('button', { name: /count is 0/i });
  await expect(button).toBeVisible();

  await button.click();

  // After one click the button text should update
  await expect(page.getByRole('button', { name: /count is 1/i })).toBeVisible();
});

import { describe, it, beforeEach, expect, vi } from "vitest";

// Mock contract methods for 2SureOddBet
const mockContract = {
  createBet: vi.fn(),
  placeBet: vi.fn(),
  closeBetting: vi.fn(),
  setWinnerAndPayout: vi.fn(),
  claimPayout: vi.fn(),
  getBetDetails: vi.fn(),
  getUserBet: vi.fn(),
};

describe("2SureOddBet Smart Contract", () => {
  beforeEach(() => {
    // Reset all mocks before each test
    vi.resetAllMocks();
  });
});

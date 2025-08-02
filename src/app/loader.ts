import { desc } from 'drizzle-orm'

import { db } from '@/lib/db/db'
import * as schema from '@/lib/db/schema'
import type { TestSuiteDefinition } from '@/lib/testing/engine'
import { BROWSERUSE_DOCS_TEST_SUITE } from '@/lib/testing/mock'

const MOCK_SUITE: TestSuiteDefinition = BROWSERUSE_DOCS_TEST_SUITE

export async function loader() {
  const suites = await db.query.suite.findMany({
    orderBy: [desc(schema.suite.createdAt)],
    with: { tests: true },
  })

  // NOTE: We always seed the mock suite to make sure you can see something!
  if (suites.length === 0) {
    // Insert the suite
    const insertedSuite = await db
      .insert(schema.suite)
      .values({
        name: MOCK_SUITE.label,
      })
      .returning()
      .get()

    // Insert tests and steps
    for (const test of MOCK_SUITE.tests) {
      const insertedTest = await db
        .insert(schema.test)
        .values({
          label: test.label,
          evaluation: test.evaluation,
          suiteId: insertedSuite.id,
        })
        .returning()
        .get()

      // Insert steps for this test
      await db
        .insert(schema.testStep)
        .values(
          test.steps.map((step, i) => ({
            testId: insertedTest.id,
            order: i + 1,
            description: typeof step === 'string' ? step : step.description,
          })),
        )
        .run()
    }

    return await db.query.suite.findMany({
      orderBy: [desc(schema.suite.createdAt)],
      with: { tests: true },
    })
  }

  return suites
}

export type TPageData = Awaited<ReturnType<typeof loader>>

export type TSuite = typeof schema.suite.$inferSelect

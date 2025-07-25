import { CheckCircle, Loader2, XCircle } from 'lucide-react'

import type * as schema from '@/lib/db/schema'
import { ExhaustiveSwitchCheck } from '@/lib/types'

/**
 * Renders a generic badge for a run status.
 */
export function RunStatusIcon({ status }: { status: schema.TRunStatus }) {
  switch (status) {
    case 'passed':
      return <CheckCircle className="w-4 h-4 text-green-500" />
    case 'failed':
      return <XCircle className="w-4 h-4 text-red-500" />
    case 'pending':
      return <Loader2 className="w-4 h-4 text-gray-500 animate-spin" />
    case 'running':
      return <Loader2 className="w-4 h-4 text-gray-500 animate-spin" />
    default:
      throw new ExhaustiveSwitchCheck(status)
  }
}

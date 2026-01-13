'use strict'

import { hashSync, compareSync } from 'bcryptjs'

const SALT_ROUNDS = 10

export const hashPassword = (pw) => hashSync(pw, SALT_ROUNDS)
export const comparePassword = (pwInput, pwDB) => compareSync(pwInput, pwDB)

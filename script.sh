#!/bin/sh
set -e

TYPOS_VERSION=v1.22.7

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group::🐶 Installing typos ... https://github.com/crate-ci/typos'
TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"
wget -O - -q https://raw.githubusercontent.com/crate-ci/gh-install/057430d007bc58dc624003c9af8ff9cf1f747c66/v1/install.sh |
  sh -s -- --tag "${TYPOS_VERSION}" --git crate-ci/typos --target x86_64-unknown-linux-musl --to "${TEMP_PATH}"
echo '::endgroup::'

echo '::group:: Running typos with reviewdog 🐶 ...'
# shellcheck disable=SC2086
typos ${INPUT_TYPOS_FLAGS} --format json |
  jq -f "${GITHUB_ACTION_PATH}/to-rdjsonl.jq" -c |
  reviewdog \
    -f="rdjsonl" \
    -name="${INPUT_TOOL_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    -tee \
    ${INPUT_REVIEWDOG_FLAGS}
exit_code=$?
echo '::endgroup::'
exit $exit_code

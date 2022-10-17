<template>
  <div>
    <a-row :gutter="12">
      <a-col :lg="10" :md="24" class="pb-3">
        <a-card :bodyStyle="{ padding: '16px' }" :bordered="false">
          点击可修改背景图片
          <div class="mb-6 text-center">
            <a-tooltip :trigger="['hover']" placement="right" title="点击可修改背景图片">
              <a-avatar
                :size="104"
                :src="userForm.model.avatar || '//cn.gravatar.com/avatar/?s=256&d=mm'"
                class="cursor-pointer"
                @click="handleOpenUpdateAvatarForm"
              />
            </a-tooltip>
            <div class="mt-4 mb-1 text-xl font-medium leading-5" style="color: rgba(0, 0, 0, 0.85)">
              {{ userForm.model.nickname }}
            </div>
            <div>{{ userForm.model.description }}</div>
          </div>
          <div>
            <p class="mb-3">
              <a-icon class="mr-3" type="link" />
              <a :href="options.blog_url" target="method">{{ options.blog_url }}</a>
            </p>
            <p class="mb-3">
              <a-icon class="mr-3" type="mail" />
              {{ userForm.model.email }}
            </p>
            <p class="mb-3">
              <a-icon class="mr-3" type="calendar" />
              {{ statistics.data.establishDays || 0 }} 天
            </p>
          </div>
          <a-divider />
        </a-card>
      </a-col>
    </a-row>

    <a-modal v-model="updateAvatarForm.visible" title="修改头像">
      <a-form layout="vertical">
        <a-form-item label="头像链接：">
          <AttachmentInput ref="avatarInput" v-model="updateAvatarForm.avatar" />
        </a-form-item>
      </a-form>

      <template #footer>
        <a-button type="primary" @click="handleUpdateAvatar">确定</a-button>
        <a-button @click="updateAvatarForm.visible = false">关闭</a-button>
      </template>
    </a-modal>
  </div>
</template>

<script>
import apiClient from '@/utils/api-client'
import { mapGetters, mapMutations } from 'vuex'

export default {
  data() {
    return {
      attachmentSelect: {
        visible: false
      },
      updateAvatarForm: {
        avatar: undefined,
        visible: false,
        saving: false,
        saveErrored: false
      },
      userForm: {
        model: {},
        saving: false,
        errored: false
      },
      statistics: {
        data: {},
        loading: false
      },
      passwordForm: {
        model: {
          oldPassword: null,
          newPassword: null,
          confirmPassword: null
        },
        saving: false,
        errored: false
      }
    }
  },
  computed: {
    ...mapGetters(['options']),
    mfaType() {
      return this.mfaParam.mfaType
    },
    mfaUsed() {
      return this.mfaParam.mfaUsed
    }
  },
  created() {
    this.handleLoadStatistics()
  },
  methods: {
    ...mapMutations({ setUser: 'SET_USER' }),

    handleLoadStatistics() {
      this.statistics.loading = true
      apiClient.statistic
        .statisticsWithUser()
        .then(response => {
          this.userForm.model = response.data.user
          this.statistics.data = response.data
          this.mfaParam.mfaType = this.userForm.model.mfaType && this.userForm.model.mfaType
        })
        .finally(() => {
          this.statistics.loading = false
        })
    },
    handleUpdatePassword() {
      const _this = this
      _this.$refs.passwordForm.validate(valid => {
        if (valid) {
          this.passwordForm.saving = true
          apiClient.user
            .updatePassword(this.passwordForm.model)
            .catch(() => {
              this.passwordForm.errored = true
            })
            .finally(() => {
              setTimeout(() => {
                this.passwordForm.saving = false
              }, 400)
            })
        }
      })
    },
    handleUpdatedPasswordCallback() {
      if (this.passwordForm.errored) {
        this.passwordForm.errored = false
      } else {
        this.passwordForm.model.oldPassword = null
        this.passwordForm.model.newPassword = null
        this.passwordForm.model.confirmPassword = null
      }
    },
    handleUpdateProfile() {
      const _this = this
      _this.$refs.userForm.validate(valid => {
        if (valid) {
          this.userForm.saving = true
          apiClient.user
            .updateProfile(this.userForm.model)
            .then(response => {
              this.userForm.model = response.data
              this.setUser(Object.assign({}, this.userForm.model))
            })
            .catch(() => {
              this.userForm.errored = true
            })
            .finally(() => {
              setTimeout(() => {
                this.userForm.saving = false
              }, 400)
            })
        }
      })
    },
    handleUpdatedProfileCallback() {
      if (this.userForm.errored) {
        this.userForm.errored = false
      }
    },
    handleOpenUpdateAvatarForm() {
      this.updateAvatarForm.avatar = this.userForm.model.avatar
      this.updateAvatarForm.visible = true
      this.$nextTick(() => {
        this.$refs.avatarInput.focus()
      })
    },
    handleUpdateAvatar() {
      this.userForm.model.avatar = this.updateAvatarForm.avatar
      this.updateAvatarForm.visible = false
    }
  }
}
</script>

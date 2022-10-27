<template>
  <div>
    <a-row :gutter="15">
      <a-form-model ref="elForm" :model="formData" :rules="rules" :label-col="{ span: 3,
      offset: 0 }" :wrapper-col="{ span: 21,
      offset: 0 }" layout="horizontal">
        <a-col :span="12">
          <a-form-model-item label="首页视频上传" prop="field110">
            <a-upload ref="field110" :file-list="field110fileList" :action="field110Action"
                      :before-upload="field110BeforeUpload" accept="video/*">
              <a-button>
                <a-icon type="upload" /> 点击上传
              </a-button>
            </a-upload>
          </a-form-model-item>
        </a-col>
        <a-col :span="24">
          <a-form-model-item :wrapper-col="{ span: 21, offset: 3 }">
            <a-space>
              <a-button type="primary" @click="submitForm">提交</a-button>
              <a-button @click="resetForm">重置</a-button>
            </a-space>
          </a-form-model-item>
        </a-col>
      </a-form-model>
    </a-row>
  </div>
</template>
<script>
export default {
  components: {},
  props: [],
  data() {
    return {
      formData: {
        field110: null,
      },
      rules: {},
      field110Action: 'https://jsonplaceholder.typicode.com/posts/',
      field110fileList: [],
    }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {
    submitForm() {
      this.$refs['elForm'].validate(valid => {
        if (!valid) return
      })
    },
    resetForm() {
      this.$refs['elForm'].resetFields()
    },
    field110BeforeUpload(file) {
      let isRightSize = file.size / 1024 / 1024 < 2
      if (!isRightSize) {
        this.$message.error('文件大小超过 2MB')
      }
      let isAccept = new RegExp('video/*').test(file.type)
      if (!isAccept) {
        this.$message.error('应该选择此类型文件:video/*')
      }
      return isRightSize && isAccept
    },
  }
}

</script>
<style>
</style>
